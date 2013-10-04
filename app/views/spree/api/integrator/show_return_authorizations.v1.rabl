object false

child(:return_authorizations => :return_authorizations) do
  child(@return_authorizations => :page) do
    attributes *return_authorization_attributes
  end

  node(:count) { @return_authorizations.count }
  node(:current_page) { @page }
  node(:pages) { @return_authorizations.num_pages }
end
