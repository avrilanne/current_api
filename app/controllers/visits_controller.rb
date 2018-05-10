class VisitsController < ApplicationController
  def index
    visit_params
    if visit_params.include?(:visit_id)
      set_visit
    elsif visit_params.include?(:visit_id && :search_string)
      find_by_user_id_and_search_string
    end
    json_response(@visit)
  end

  def create
    @visit = Visit.create!(visit_params)
    json_response(@visit, :created)
  end

  private

  def visit_params
    params.permit(:user_id, :name, :visit_id, :search_string)
  end

  def set_visit
    @visit = Visit.find(params[:visit_id])
  end

  def find_by_user_id_and_search_string
    user_visits = Visit.where(user_id: visit_params['user_id'])
    return @visit = [] if user_visits == nil
    if user_visits.class != Visit
      user_visits = user_visits.order(:created_at).limit(5)
    end
    @visit = try_match(user_visits)
  end

  def try_match(user_visits)
    fz = FuzzyMatch.new([user_visits][0], read: :name)
    [fz.find(visit_params['search_string'])]
  end
end
