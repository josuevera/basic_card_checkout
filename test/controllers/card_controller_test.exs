defmodule PhoenixCharges.CardControllerTest do
  use PhoenixCharges.ConnCase

  alias PhoenixCharges.Card
  @valid_attrs %{address: "some content", cvv: 42, email: "some content", month: "some content", name: "some content", number: "some content", tokenCreated: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, token_id: "some content", year: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, card_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    card = Repo.insert! %Card{}
    conn = get conn, card_path(conn, :show, card)
    assert json_response(conn, 200)["data"] == %{"id" => card.id,
      "name" => card.name,
      "number" => card.number,
      "month" => card.month,
      "year" => card.year,
      "cvv" => card.cvv,
      "address" => card.address,
      "email" => card.email,
      "token_id" => card.token_id,
      "tokenCreated" => card.tokenCreated}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, card_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, card_path(conn, :create), card: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Card, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, card_path(conn, :create), card: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    card = Repo.insert! %Card{}
    conn = put conn, card_path(conn, :update, card), card: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Card, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    card = Repo.insert! %Card{}
    conn = put conn, card_path(conn, :update, card), card: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    card = Repo.insert! %Card{}
    conn = delete conn, card_path(conn, :delete, card)
    assert response(conn, 204)
    refute Repo.get(Card, card.id)
  end
end
