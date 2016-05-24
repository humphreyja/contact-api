defmodule ContactApi.SmartTextController do
  use ContactApi.Web, :controller
  require Apex
  alias ContactApi.Contact
  alias ContactApi.SmartScrub

  plug :scrub_params, "smarttext" when action in [:create]

  def create(conn, %{"smarttext" => smartstring}) do

    smarthash = %{text: smartstring}

    smarthash = smarthash
    |> SmartScrub.scrub_emails
    |> SmartScrub.scrub_phone_numbers
    |> SmartScrub.scrub_labels
    |> SmartScrub.scrub_name

    changeset = Contact.changeset(
      %Contact{user_id: conn.assigns.current_user.id}, smarthash.contact
    )

    case Repo.insert(changeset) do
      {:ok, contact} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", contact_path(conn, :show, contact))
        |> render(ContactApi.ContactView, "show.json", contact: contact)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContactApi.ChangesetView, "error.json", changeset: changeset)
    end
    render(conn, ContactApi.ErrorView, "403.json", %{message: "Unauthorized"})
  end






end
