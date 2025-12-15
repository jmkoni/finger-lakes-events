import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["latitude", "longitude", "location", "button", "status", "searchResults"]

  connect() {
    // Check if geolocation is available
    if (!navigator.geolocation) {
      this.showStatus("Geolocation is not supported by your browser", "error")
      if (this.hasButtonTarget) {
        this.buttonTarget.disabled = true
      }
    }
    
    // Debounce timer for search
    this.searchTimeout = null
    // Flag to track if we're in selection mode
    this.isSelecting = false
  }

  disconnect() {
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout)
    }
  }

  getCurrentLocation(event) {
    event.preventDefault()
    
    this.showStatus("Getting your location...", "loading")
    
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
    }

    navigator.geolocation.getCurrentPosition(
      (position) => this.handleSuccess(position),
      (error) => this.handleError(error),
      {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0
      }
    )
  }

  handleSuccess(position) {
    const latitude = position.coords.latitude
    const longitude = position.coords.longitude
    
    // Set the hidden fields
    if (this.hasLatitudeTarget) {
      this.latitudeTarget.value = latitude
    }
    if (this.hasLongitudeTarget) {
      this.longitudeTarget.value = longitude
    }
    
    // Perform reverse geocoding to get address
    this.reverseGeocode(latitude, longitude)
  }

  async reverseGeocode(latitude, longitude) {
    try {
      // Using Nominatim (OpenStreetMap) for reverse geocoding - free and no API key required
      const response = await fetch(
        `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}&addressdetails=1`,
        {
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'FingerLakesEvents/1.0'
          }
        }
      )
      
      if (!response.ok) {
        throw new Error('Geocoding service unavailable')
      }
      
      const data = await response.json()
      
      // Format the address
      const address = this.formatAddress(data.address)
      
      // Update the location text field with the formatted address
      if (this.hasLocationTarget) {
        this.locationTarget.value = address
      }
    } catch (error) {
      console.error('Reverse geocoding error:', error)
      
      // Fallback to coordinates if geocoding fails
      if (this.hasLocationTarget) {
        this.locationTarget.value = `${latitude.toFixed(6)}, ${longitude.toFixed(6)}`
      }
    } finally {
      if (this.hasButtonTarget) {
        this.buttonTarget.disabled = false
      }
    }
  }

  formatAddress(addressData) {
    // Build a human-readable address from the components
    const parts = []
    
    // Add venue/building name if available
    if (addressData.amenity || addressData.building) {
      parts.push(addressData.amenity || addressData.building)
    }
    
    // Add street address
    if (addressData.house_number && addressData.road) {
      parts.push(`${addressData.house_number} ${addressData.road}`)
    } else if (addressData.road) {
      parts.push(addressData.road)
    }
    
    // Add city/town/village
    const city = addressData.city || addressData.town || addressData.village || addressData.hamlet
    if (city) {
      parts.push(city)
    }
    
    // Add state
    if (addressData.state) {
      parts.push(addressData.state)
    }
    
    // If we have very few parts, include the postcode
    if (parts.length < 3 && addressData.postcode) {
      parts.push(addressData.postcode)
    }
    
    return parts.join(', ') || 'Location detected'
  }

  // Address search functionality
  searchAddress(event) {
    // Don't search if we're in the middle of selecting a result
    if (this.isSelecting) {
      return
    }
    
    const query = event.target.value.trim()
    
    // Clear previous timeout
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout)
    }
    
    // Clear results if query is too short
    if (query.length < 3) {
      this.clearSearchResults()
      return
    }
    
    // Debounce the search
    this.searchTimeout = setTimeout(() => {
      this.performSearch(query)
    }, 500)
  }

  async performSearch(query) {
    try {
      this.showSearchStatus("Searching...")
      
      // Using Nominatim for forward geocoding
      // Bias results towards Finger Lakes region (NY state)
      const response = await fetch(
        `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}&addressdetails=1&limit=5&countrycodes=us&viewbox=-77.5,43.5,-76,42&bounded=0`,
        {
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'FingerLakesEvents/1.0'
          }
        }
      )
      
      if (!response.ok) {
        throw new Error('Search service unavailable')
      }
      
      const results = await response.json()
      this.displaySearchResults(results)
      
    } catch (error) {
      console.error('Address search error:', error)
      this.showSearchStatus("Search failed. Please try again.")
    }
  }

  displaySearchResults(results) {
    if (!this.hasSearchResultsTarget) return
    
    if (results.length === 0) {
      this.searchResultsTarget.innerHTML = '<div class="search-result-item no-results">No locations found</div>'
      this.searchResultsTarget.style.display = 'block'
      return
    }
    
    const resultsHTML = results.map(result => {
      const displayName = result.display_name
      return `
        <div class="search-result-item" 
             data-lat="${result.lat}" 
             data-lon="${result.lon}"
             data-address="${this.formatAddress(result.address)}"
             data-action="click->geolocation#selectSearchResult">
          <div class="result-name">${displayName}</div>
        </div>
      `
    }).join('')
    
    this.searchResultsTarget.innerHTML = resultsHTML
    this.searchResultsTarget.style.display = 'block'
  }

  selectSearchResult(event) {
    const item = event.currentTarget
    const lat = parseFloat(item.dataset.lat)
    const lon = parseFloat(item.dataset.lon)
    const address = item.dataset.address
    
    // Set flag to prevent search triggering on value change
    this.isSelecting = true
    
    // Set the coordinates
    if (this.hasLatitudeTarget) {
      this.latitudeTarget.value = lat
    }
    if (this.hasLongitudeTarget) {
      this.longitudeTarget.value = lon
    }
    
    // Set the location field
    if (this.hasLocationTarget) {
      this.locationTarget.value = address
    }
    
    // Clear results
    this.clearSearchResults()

    // Reset flag after a short delay
    setTimeout(() => {
      this.isSelecting = false
    }, 100)
  }

  clearSearchResults() {
    if (this.hasSearchResultsTarget) {
      this.searchResultsTarget.innerHTML = ''
      this.searchResultsTarget.style.display = 'none'
    }
  }

  showSearchStatus(message) {
    if (this.hasSearchResultsTarget) {
      this.searchResultsTarget.innerHTML = `<div class="search-status">${message}</div>`
      this.searchResultsTarget.style.display = 'block'
    }
  }

  // Close search results when clicking outside
  closeSearchResults(event) {
    if (!this.element.contains(event.target)) {
      this.clearSearchResults()
    }
  }

  handleError(error) {
    let message = "Unable to retrieve your location"
    
    switch(error.code) {
      case error.PERMISSION_DENIED:
        message = "Location access denied. Please enable location permissions."
        break
      case error.POSITION_UNAVAILABLE:
        message = "Location information unavailable."
        break
      case error.TIMEOUT:
        message = "Location request timed out."
        break
    }
    
    this.showStatus(message, "error")
    
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = false
    }
  }

  showStatus(message, type) {
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = message
      this.statusTarget.className = `status-message status-${type}`
      
      // Auto-hide success messages after 5 seconds
      if (type === "success") {
        setTimeout(() => {
          this.statusTarget.textContent = ""
          this.statusTarget.className = ""
        }, 5000)
      }
    }
  }
}
