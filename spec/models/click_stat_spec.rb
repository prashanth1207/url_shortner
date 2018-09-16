require 'spec_helper'

describe ClickStat do
  describe 'check association with url' do
    it "click_stat should belong to url" do
      assc = described_class.reflect_on_association(:url)
      expect(assc.macro).to eq :belongs_to
    end
  end
end
