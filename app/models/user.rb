class User
  # Allow for timestamps via Mongn
  include Mongoid::Document
  include Mongoid::Timestamps

  # Field definition
  field :firstName,   type: String
  field :lastName,    type: String
  field :email,       type: String
  field :password,    type: String
  field :phoneNumber, type: String
  field :address,     type: Hash

  # Field validation
  validates :firstName, :lastName, :email, :password, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }
  validates :phoneNumber, format: { with: /\A\d{10,15}\z/, message: "Sorry! It must be a valid phone number" }

  #Invoke normalisation function data before saving
  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase if email.present? # Ensure emails are saved in lowercase
  end
end
