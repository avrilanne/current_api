require 'rails_helper'

RSpec.describe Visit, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:name) }
end