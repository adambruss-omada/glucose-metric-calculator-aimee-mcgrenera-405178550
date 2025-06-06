class Api::V1::MetricsController < ApplicationController
  def show
    member = Member.find(params[:member_id])
    return render json: { error: "Member not found" }, status: 404 unless member

    period = params[:period]&.to_sym
    allowed_periods = %i[last_7_days previous_week this_month last_month]

    unless allowed_periods.include?(period)
      return render json: { error: "Invalid period" }, status: 400
    end

    calculator = GlucoseMetrics::Calculator.new(member: member)
    metrics = calculator.metrics_for(period)

    render json: {
      member_id: member.id,
      period: period,
      metrics: metrics
    }
  end
end
