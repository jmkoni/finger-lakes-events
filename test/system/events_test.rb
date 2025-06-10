require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @user = User.create(name: "test user", email: "testemail@example.com")
    sign_in @user
    @event = Event.create(
      title: "Test Event",
      start_time: Time.current,
      end_time: Time.current + 1.hour,
      description: "This is a test event.",
      location: "Test Location",
      cost: 0,
      pre_registration_required: false,
      tags: ["art", "charity"],
      url: "http://example.com/test-event",
      status: "pending"
    )
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Finger Lakes Events"
  end

  test "should create event" do
    visit events_url
    click_on "New event"

    fill_in "Title", with: @event.title
    fill_in "Cost", with: @event.cost
    fill_in "Description", with: @event.description
    fill_in "Tags", with: @event.tags
    fill_in "Start time", with: @event.start_time.to_s
    fill_in "Url", with: @event.url
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back to events"
  end

  test "should update Event" do
    visit event_url(@event)
    click_on "Edit this event", match: :first

    fill_in "Title", with: "New title"
    click_on "Update Event"

    assert_text "Event was successfully updated"
    @event.reload
    assert_equal "New title", @event.title
    click_on "Back"
  end

  test "should destroy Event" do
    visit event_url(@event)
    click_on "Destroy this event", match: :first

    assert_text "Event was successfully destroyed"
  end
end
