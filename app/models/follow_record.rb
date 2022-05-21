class FollowRecord < ApplicationRecord
  # 默认scope
  default_scope { where(delete_time: 0) }
end
