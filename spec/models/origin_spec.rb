require 'rails_helper'

RSpec.describe Origin, type: :model do
  describe '.find_or_create_by_name' do
    it 'finds existing origin' do
      origin = Origin.create(name: SecureRandom.hex)
      expect(Origin.find_or_create_by_name(origin.name)).to eql(origin)
    end

    it 'creates new origin when not found' do
      expect do
        Origin.find_or_create_by_name(SecureRandom.hex)
      end.to change(Origin, :count).by(1)
    end

    it 'retries on unique violation' do
      error = ActiveRecord::RecordNotUnique.new(Origin.new)
      expect(Origin).to receive(:create).and_raise(error).and_call_original
      expect do
        Origin.find_or_create_by_name(SecureRandom.hex)
      end.to change(Origin, :count).by(1)
    end
  end
end
