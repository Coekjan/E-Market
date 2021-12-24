class Complaint < ApplicationRecord
  belongs_to :customer
  belongs_to :seller
  belongs_to :admin, :optional => true

  def is_handled
    not self.admin.nil?
  end
end
