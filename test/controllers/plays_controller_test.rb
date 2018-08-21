require 'test_helper'

class PlaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @play = plays(:one)
  end

  test "should get index" do
    get plays_url
    assert_response :success
  end

  test "should get new" do
    get new_play_url
    assert_response :success
  end

  test "should create play" do
    assert_difference('Play.count') do
      post plays_url, params: { play: { 1dart: @play.1dart, 2dart: @play.2dart, 3dart: @play.3dart, game_id: @play.game_id, leg: @play.leg, player: @play.player, set: @play.set, turn: @play.turn } }
    end

    assert_redirected_to play_url(Play.last)
  end

  test "should show play" do
    get play_url(@play)
    assert_response :success
  end

  test "should get edit" do
    get edit_play_url(@play)
    assert_response :success
  end

  test "should update play" do
    patch play_url(@play), params: { play: { 1dart: @play.1dart, 2dart: @play.2dart, 3dart: @play.3dart, game_id: @play.game_id, leg: @play.leg, player: @play.player, set: @play.set, turn: @play.turn } }
    assert_redirected_to play_url(@play)
  end

  test "should destroy play" do
    assert_difference('Play.count', -1) do
      delete play_url(@play)
    end

    assert_redirected_to plays_url
  end
end
