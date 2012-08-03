Flatpage.all.each do |flatpage|
  if flatpage.updated_at.present?
    puts "Flatpage ##{flatpage.id}: Setting created_at to #{flatpage.updated_at}"
    flatpage.update_column(:created_at, flatpage.updated_at)
  else
    puts "Flatpage ##{flatpage.id}: Setting updated_at to #{flatpage.created_at}"
    flatpage.update_column(:updated_at, flatpage.created_at)
  end
end
