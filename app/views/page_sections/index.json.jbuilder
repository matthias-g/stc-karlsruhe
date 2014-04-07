json.array!(@page_sections) do |page_section|
  json.extract! page_section, :id, :title, :content
  json.url page_section_url(page_section, format: :json)
end
