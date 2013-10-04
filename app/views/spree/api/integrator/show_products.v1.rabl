object false

child(:products => :products) do
  child(@products => :page) do
    attributes *product_attributes
  end

  node(:count) { @products.count }
  node(:current_page) { @page }
  node(:pages) { @products.num_pages }
end
