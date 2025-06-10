require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
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

  test "should get index" do
    get events_path
    assert_response :success
  end

  test "should get new" do
    get new_event_path
    assert_response :success
  end

  test "should create event" do
    assert_difference("Event.count") do
      post events_path, params: {event: {title: "brand new event", start_time: @event.start_time, end_time: @event.end_time, cost: @event.cost, description: @event.description, tags: @event.tags, url: @event.url}}
    end

    assert_redirected_to event_path(Event.last)
  end

  test "should show event" do
    get event_path(@event)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_path(@event)
    assert_response :success
  end

  test "should update event" do
    post approve_event_path(@event)
    assert_redirected_to event_path(@event)
    @event.reload
    assert @event.approved_by_id == @user.id
    assert @event.status == "approved"
  end

  test "should destroy event" do
    assert_difference("Event.count", -1) do
      delete event_path(@event)
    end

    assert_redirected_to events_path
  end
end
