Then /^I should see the following dishes:$/ do |table|
  table.hashes.each do |row|
    within(".dishes") do
      %w[name rating].each do |field|
        within(".#{field}") do
          page.should have_content(row[field])
        end
      end
      within(".status .body") do
        page.should have_content(row["status"])
      end
      within(".status .rating") do
        page.should have_content(row["status_rating"])
      end
    end
  end
end