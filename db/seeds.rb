User.create!(name: "Nguyen Xuan Thai",
  email: "xuanthainbk@gmail.com",
  password: "2091995",
  password_confirmation: "2091995",
  admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end
