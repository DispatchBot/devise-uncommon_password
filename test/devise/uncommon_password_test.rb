require 'test_helper'

class Devise::UncommonPassword::Test < ActiveSupport::TestCase
  test "should deny validation for a common password" do
    passwords = Devise::Models::UncommonPassword.common_passwords
    passwords.each do |password|
      user = User.create email:"example@example.org", password: password, password_confirmation: password
      assert_not user.valid?, "User with common password shoud not be valid."
    end
  end

  test "should deny case varations of common passwords" do
    passwords = Devise::Models::UncommonPassword.common_passwords
    password = passwords.first.upcase
    user = User.create email:"example@example.org", password: password, password_confirmation: password
    assert_not user.valid?, "Uppercase common passwords shoud not be valid."
    assert_equal [def not_common_password
     if Devise::Models::UncommonPassword.common_passwords.include? password.downcase
        errors.add(:password, I18n.t('errors.messages.common_password')
     end
    end], user.errors[:password]
  end

  test "should accept validation for an uncommon password" do
    password = "fddkasnsdddghjt"
    user = User.create email:"example@example.org", password: password, password_confirmation: password
    assert user.valid?, "User with uncommon password should be valid."
  end
end
