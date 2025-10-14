# User.create!(
#   name: "Admin",
#   email: "admin@gmail.com",
#   password: "123456789",
#   password_confirmation: "123456789",
#   phone: "9876543210",
#   is_admin: true
# )
# User.create!(
#   name: "User",
#   email: "user@gmail.com",
#   password: "123456789",
#   password_confirmation: "123456789",
#   phone: "1234567890",
#   is_admin: false
# )
# Theatre.create!(
#   name: "PVR Cinemas",
#   address: "123 Main St",
#   city: "Mumbai",
#   state: "MH",
#   country: "India",
#   rating: 4.5
# )
# Theatre.create!(
#   name: "INOX",
#   address: "456 Park Lane",
#   city: "Delhi",
#   state: "DL",
#   country: "India",
#   rating: 4.2
# )

# Tag.create!([
#               { name: "Action" },
#               { name: "Adventure" },
#               { name: "Comedy" },
#               { name: "Drama" },
#               { name: "Horror" },
#               { name: "Sci-Fi" },
#               { name: "Romance" },
#               { name: "Thriller" },
#               { name: "Animation" },
#               { name: "Fantasy" }
#             ])

# Movie.create!(
#   title: "Inception",
#   description: "A skilled thief, the absolute best in the dangerous art of extraction, steals valuable secrets from deep within the subconscious during dream states.",
#   poster_image: "m1.png",
#   release_date: "2010-07-16",
#   duration: 148, # in minutes
#   rating: 4.5
# )
# Movie.create!(
#   title: "Avengers: Endgame",
#   description: "After the devastating events of Avengers: Infinity War, the universe is in ruins. The remaining Avengers assemble once more to reverse Thanos' actions and restore balance.",
#   poster_image: "m1.png", # relative to app/assets/images/
#   release_date: "2019-04-26",
#   duration: 181, # in minutes
#   rating: 4.3
# )

# Screen.create!(
#   name: "Screen 1",
#   total_seats: 200,
#   screen_type: "2D",
#   theatre_id: 1
# )
# Screen.create!(
#   name: "Screen 2",
#   total_seats: 150,
#   screen_type: "3D",
#   theatre_id: 2
# )

# Showtime.create!(
#   movie_id: 1,
#   screen_id: 3,
#   start_time: "2025-10-12 10:00",
#   end_time: "2025-10-12 13:00",
#   language: "English",
#   available_seats: 200
# )
#
# Showtime.create!(
#   movie_id: 2,
#   screen_id: 4,
#   start_time: "2025-10-12 14:00",
#   end_time: "2025-10-12 17:00",
#   language: "English",
#   available_seats: 150
# )
