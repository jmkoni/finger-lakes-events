require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    Passwordless::Session.stubs(:find_by).returns(Passwordless::Session.create(authenticatable: @user))
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Finger Lakes Events"
  end

  test "should create event" do
    skip("not sure how to get around this datepicker")
    visit events_url
    click_on "New event"

    fill_in "Title", with: @event.title
    fill_in "Cost", with: @event.cost
    fill_in "Description", with: @event.description
    select = find("#event_tags")
    @event.tags.each do |tag|
      select.select(tag)
    end
    page.execute_script("document.querySelector('#event_start_time').setAttribute('value', #{@event.start_time.strftime("%Y-%m-%dT%H:%M:%S")})")
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

  test "should approve event" do
    visit list_events_url
    click_on(class: "approve-event-#{@event.id}")
    assert text "Event was successfully approved."
    @event.reload
    assert_equal "approved", @event.status
    assert_equal @user.id, @event.approved_by_id
  end

  test "should reject event" do
    visit list_events_url
    click_on(class: "reject-event-#{@event.id}")
    assert text "Event was successfully rejected."
    @event.reload
    assert_equal "rejected", @event.status
    assert_equal @user.id, @event.approved_by_id
  end

  test "should destroy Event" do
    visit event_url(@event)
    click_on "Destroy this event", match: :first

    assert_text "Event was successfully destroyed"
  end
end
