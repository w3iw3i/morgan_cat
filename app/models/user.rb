class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :expenses, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :monthly_income, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :monthly_expenses, numericality: { greater_than_or_equal_to: 0 }, presence: true

  def self.sample_data
  end
end
