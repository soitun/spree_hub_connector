object false

child(:users => :users) do
  child(@users => :page) do
    attributes *user_attributes
  end

  node(:count) { @users.count }
  node(:current_page) { @page }
  node(:pages) { @users.num_pages }
end
