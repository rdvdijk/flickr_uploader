require 'spec_helper'


module FlickrUploader

  class EpicFailer
    include RescueRetry

    attr_accessor :fail_count
    attr_accessor :times
    attr_accessor :sleep_on_fail

    def initialize
      self.times = RescueRetry::DEFAULTS[:times]
      self.sleep_on_fail = RescueRetry::DEFAULTS[:sleep]
    end

    def fail!
      rescue_retry({times: self.times, sleep: self.sleep_on_fail}) do
        code_that_fails
      end
    end

    private

    def code_that_fails
      self.fail_count = self.fail_count - 1
      raise "Epically." if fail_count > 0
    end
  end

  describe RescueRetry do

    subject do
      EpicFailer.new
    end

    context "defaults" do
      it "should fail after default raise limit was reached" do
        subject.fail_count = 6
        expect { subject.fail! }.to raise_error
      end

      it "should not fail if default raise limit was not reached" do
        subject.fail_count = 4
        expect { subject.fail! }.not_to raise_error
      end
    end

    context "custom times" do
      it "should fail after custom raise limit was reached" do
        subject.fail_count = 2
        subject.times = 1
        expect { subject.fail! }.to raise_error
      end

      it "should not fail after custom raise limit was not reached" do
        subject.fail_count = 2
        subject.times = 3
        expect { subject.fail! }.not_to raise_error
      end
    end

    context "custom wait" do
      it "should wait between tries when configured to" do
        subject.fail_count = 2
        subject.times = 3
        subject.sleep_on_fail = 0.5
        subject.should_receive(:sleep).with(0.5)
        expect { subject.fail! }.not_to raise_error
      end

      it "should not wait between tries if not configured to" do
        subject.fail_count = 2
        subject.times = 3
        subject.should_not_receive(:sleep)
        expect { subject.fail! }.not_to raise_error
      end
    end

  end
end
