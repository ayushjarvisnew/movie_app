puts "🌱 Seeding data..."

# === USERS ===
admin = User.find_or_create_by!(email: "admin@gmail.com") do |user|
  user.name = "Admin"
  user.password = "123456789"
  user.password_confirmation = "123456789"
  user.phone = "9876543210"
  user.is_admin = true
end

user = User.find_or_create_by!(email: "user@gmail.com") do |user|
  user.name = "User"
  user.password = "123456789"
  user.password_confirmation = "123456789"
  user.phone = "1234567890"
  user.is_admin = false
end

# === THEATRES ===
pvr = Theatre.find_or_create_by!(name: "PVR Cinemas") do |t|
  t.address = "123 Main St"
  t.city = "Mumbai"
  t.state = "MH"
  t.country = "India"
  t.rating = 4.5
end

inox = Theatre.find_or_create_by!(name: "INOX") do |t|
  t.address = "456 Park Lane"
  t.city = "Delhi"
  t.state = "DL"
  t.country = "India"
  t.rating = 4.2
end

# === TAGS ===
tags = [
  "Action", "Adventure", "Comedy", "Drama",
  "Horror", "Sci-Fi", "Romance", "Thriller",
  "Animation", "Fantasy"
]
tags.each do |tag_name|
  Tag.find_or_create_by!(name: tag_name)
end

# === MOVIES ===
inception = Movie.find_or_create_by!(title: "Inception") do |m|
  m.description = "A skilled thief steals secrets from deep within the subconscious during dream states."
  m.poster_image = "m1.png"
  m.release_date = "2010-07-16"
  m.duration = 148
  m.rating = 4.5
end

endgame = Movie.find_or_create_by!(title: "Avengers: Endgame") do |m|
  m.description = "After the events of Infinity War, the remaining Avengers assemble to reverse Thanos' actions."
  m.poster_image = "m1.png"
  m.release_date = "2019-04-26"
  m.duration = 181
  m.rating = 4.3
end

# === SCREENS ===
screen1 = Screen.find_or_create_by!(name: "Screen 1") do |s|
  s.total_seats = 200
  s.screen_type = "2D"
  s.theatre = pvr
end

screen2 = Screen.find_or_create_by!(name: "Screen 2") do |s|
  s.total_seats = 150
  s.screen_type = "3D"
  s.theatre = inox
end

# === SHOWTIMES ===
Showtime.find_or_create_by!(movie: inception, screen: screen1, start_time: "2025-10-12 10:00") do |st|
  st.end_time = "2025-10-12 13:00"
  st.language = "English"
  st.available_seats = 200
end

Showtime.find_or_create_by!(movie: endgame, screen: screen2, start_time: "2025-10-12 14:00") do |st|
  st.end_time = "2025-10-12 17:00"
  st.language = "English"
  st.available_seats = 150
end

puts "✅ Seeding complete!"
