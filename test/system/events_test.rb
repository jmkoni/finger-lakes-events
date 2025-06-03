require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "should create event" do
    visit events_url
    click_on "New event"

    fill_in "Approved", with: @event.approved
    fill_in "Approved by", with: @event.approved_by
    fill_in "Cost", with: @event.cost
    fill_in "Description", with: @event.description
    fill_in "Tags", with: @event.tags
    fill_in "Time", with: @event.time
    fill_in "Type", with: @event.type
    fill_in "Url", with: @event.url
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "should update Event" do
    visit event_url(@event)
    click_on "Edit this event", match: :first

    fill_in "Approved", with: @event.approved
    fill_in "Approved by", with: @event.approved_by
    fill_in "Cost", with: @event.cost
    fill_in "Description", with: @event.description
    fill_in "Tags", with: @event.tags
    fill_in "Time", with: @event.time.to_s
    fill_in "Type", with: @event.type
    fill_in "Url", with: @event.url
    click_on "Update Event"

    assert_text "Event was successfully updated"
    click_on "Back"
  end

  test "should destroy Event" do
    visit event_url(@event)
    click_on "Destroy this event", match: :first

    assert_text "Event was successfully destroyed"
  end
end
