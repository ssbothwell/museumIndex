require 'test_helper'

class ExhibitionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Exhibition.new.valid?
  end
end
