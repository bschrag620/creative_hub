t = Test.create(:name => "Electrical safety")

q = Question.create(:text => "Which objects are ok to still into the electrical outlet?")
q.answers << Answer.create(:text => "Fork")
q.answers << Answer.create(:text => "Kinves")
q.answers << Answer.create(:text => "Electrical cords", :is_correct => true)
q.save
t.questions << q

q = Question.create(:text => "Which objects are not ok to still into the electrical outlet?")
q.answers << Answer.create(:text => "Fork", :is_correct => true)
q.answers << Answer.create(:text => "Kinves", :is_correct => true)
q.answers << Answer.create(:text => "Kittens", :is_correct => true)
q.save
t.questions << q

t = Test.create(:name => "Cleanliness")
q = Question.create(:text => "When is it acceptable to leave messes for others to clean up?")
q.answers << Answer.create(:text => "Always")
q.answers << Answer.create(:text => "Sometimes")
q.answers << Answer.create(:text => "Rarely")
q.answers << Answer.create(:text => "Never", :is_correct => true)
t.questions << q

q = Question.create(:text => "Your momma lives here.")
q.answers << Answer.create(:text => "True")
q.answers << Answer.create(:text => "False")
q.answers << Answer.create(:text => "Doesn't matter, clean up after yourself!", :is_correct => true)
q.save
t.questions << q

c = Certificate.create(:name => "3d Printer")
Test.first.certificates << c
c = Certificate.create(:name => "CNC")
Test.last.certificates << c

admin = User.create(:first_name => "ad", :last_name => "min", :email => "brad.schrag@gmail.com", :phone_number => "479-799-2325", :password_digest => BCrypt::Password.create('admin'), :is_admin => true)
non_admin = User.create(:first_name => "Mark", :last_name => "Not important", :email => "markschmo@nowhere.com", :phone_number => "555-4123", :is_volunteer => true, :password_digest => BCrypt::Password.create('mark'))

Equipment.create(:name => "CNC", :certificate => Certificate.last)

Equipment.create(:name => "3D Printer", :certificate => Certificate.first)