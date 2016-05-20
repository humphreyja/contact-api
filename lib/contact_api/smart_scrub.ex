defmodule ContactApi.SmartScrub do
  require Apex
  def scrub_emails(smart_map) do
    text = smart_map.text

    email = Regex.named_captures(~r/(?<email>\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b)/i, text)["email"]
    smart_map = put_in(smart_map, [:text], Regex.replace(~r/(?<email>\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b)/i, text, ""))

    case email do
      nil   ->  smart_map
      _else ->  smart_map = create_contact(smart_map)
                put_in(smart_map, [:contact, :email], email)
    end
  end

  def scrub_phone_numbers(smart_map) do

    text = smart_map.text

    phone_number_info = Regex.named_captures(~r/(?<number>(\+?(?<country>(\d{1,2}))\s?)?(\(?(?<region>(\d{3}))\)?(\s|-|\.)?)((?<first>(\d{3}))(\s|-|\.)?)((?<last>(\d{4}))))/i, text)
    smart_map = put_in(smart_map, [:text], Regex.replace(~r/(?<number>(\+?(?<country>(\d{1,2}))\s?)?(\(?(?<region>(\d{3}))\)?(\s|-|\.)?)((?<first>(\d{3}))(\s|-|\.)?)((?<last>(\d{4}))))/i, text, ""))

    case phone_number_info do
      nil   ->  smart_map
      _else ->  phone_number = if phone_number_info["country"] != "", do: "+#{phone_number_info["country"]} ", else: ""
                phone_number = "#{phone_number}(#{phone_number_info["region"]}) #{phone_number_info["first"]}-#{phone_number_info["last"]}"
                smart_map = create_contact(smart_map)
                put_in(smart_map, [:contact, :phone_number], phone_number)
    end
  end

  def scrub_labels(smart_map) do
    text = smart_map.text

    label_info = Regex.named_captures(~r/((?<label>([a-z]*)):\s?(?<data>(.*?[\.!\?](?:))))/i, text)
    smart_map = put_in(smart_map, [:text], Regex.replace(~r/((?<label>([a-z]*)):\s?(?<data>(.*?[\.!\?](?:))))/i, text, "", [global: false]))

    case label_info do
      nil   ->  smart_map
      _else ->  label = label_info["label"]
                data = label_info["data"]
                smart_map = create_label(smart_map, label, data)
                scrub_labels(smart_map)
    end
  end

  def scrub_name(smart_map) do
    text = String.strip(smart_map.text)
    smart_map = put_in(smart_map, [:contact, :name], text)
    put_in(smart_map, [:text], text)
  end

  defp create_label(smart_map, label, data) do
    label = %{
      label: label,
      data: data
    }

    unless Map.has_key?(smart_map, :labels) do
      labels = %{labels: []}
      smart_map = Map.merge(smart_map, labels)
    end


    put_in(smart_map, [:labels], smart_map.labels ++ [label])
  end

  defp create_contact(smart_map) do
    if Map.has_key?(smart_map, :contact) do
      smart_map
    else
      contact = %{
        contact: %{
          name: "",
          phone_number: "",
          email: ""
          }
        }
      Map.merge(smart_map, contact)
    end
  end
end
