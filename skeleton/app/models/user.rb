# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
    has_many(:enrollments,
    class_name: :Enrollment,
    primary_key: :id,
    foreign_key: :student_id   
    )

    has_many(:teaches,
        class_name: :Course,
        primary_key: :id,
        foreign_key: :instructor_id
    )

    has_many :enrolled_courses, through: :enrollments, source: :course
end
