class Enrollment < ApplicationRecord

  belongs_to :student
  belongs_to :course

  def unenroll(student)
    destroy if student.id == self.student.id
  end
end
