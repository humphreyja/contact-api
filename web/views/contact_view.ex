defmodule ContactApi.ContactView do
  use ContactApi.Web, :view

  def render("index.json", %{contacts: contacts}) do
    %{data: render_many(contacts, ContactApi.ContactView, "contact.json")}
  end

  def render("show.json", %{contact: contact}) do
    %{data: render_one(contact, ContactApi.ContactView, "contact.json")}
  end

  def render("contact.json", %{contact: contact}) do
    %{id: contact.id,
      name: contact.name,
      email: contact.email,
      phone_number: contact.phone_number,
      user_id: contact.user_id}
  end
end
