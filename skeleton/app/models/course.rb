# == Schema Information
#
# Table name: courses
#
#  id            :bigint           not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  instructor_id :integer
#  prereq_id     :integer
#
class Course < ApplicationRecord
    has_many(:enrollments, 
    class_name: :Enrollment,
    primary_key: :id,
    foreign_key: :course_id
    )
    
    has_many :enrolled_users, through: :enrollments, source: :user
    has_one(:prerequisite,
        class_name: :Course,
        primary_key: :prereq_id,
        foreign_key: :id
    )

    belongs_to(:instructor,
        class_name: :User,
        primary_key: :id,
        foreign_key: :instructor_id
    )

end
