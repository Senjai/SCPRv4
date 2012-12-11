require "spec_helper"

describe Ticket do
  it { should belong_to(:user).class_name("AdminUser") }
end
