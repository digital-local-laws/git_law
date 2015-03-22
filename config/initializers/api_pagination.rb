ApiPagination.configure do |config|
  config.paginator = :kaminari
  config.total_header = 'X-Total'
  config.per_page_header = 'X-Per-Page'
end
