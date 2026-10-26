class Api::V1::AppliesController < ApplicationController
  before_action :set_apply, only: %i[show update destroy mark_read invite]

  # GET /v1/applies?read=true&invited=false
  # GET /v1/geeks/:geek_id/applies — заявления соискателя
  # GET /v1/jobs/:job_id/applies   — заявления на вакансию
  def index
    applies =
      if params[:geek_id]   then Geek.find(params[:geek_id]).applies
      elsif params[:job_id] then Job.find(params[:job_id]).applies
      else Apply.all
      end
    applies = applies.where(read: params[:read])       if params[:read].present?
    applies = applies.where(invited: params[:invited]) if params[:invited].present?
    render json: { applies: applies.as_json(except: %i[created_at updated_at]) }
  end

  # GET /v1/applies/:id
  def show
    render json: @apply
  end

  # POST /v1/applies
  def create
    apply = Apply.new(apply_params)
    if apply.save
      render json: apply, status: :created
    else
      render json: { apply: apply.errors, status: :unprocessable_entity },
             status: :unprocessable_entity
    end
  end

  # PUT /v1/applies/:id
  def update
    if @apply.update(apply_params)
      render json: @apply
    else
      render json: { apply: @apply.errors, status: :unprocessable_entity },
             status: :unprocessable_entity
    end
  end

  # DELETE /v1/applies/:id
  def destroy
    @apply.destroy
    render json: { deleted_apply: @apply.as_json(only: %i[id job_id geek_id]),
                   code: 200, status: :success }
  end

  # PUT /v1/applies/:id/read — компания прочитала заявление
  def mark_read
    @apply.update(read: true)
    render json: @apply
  end

  # PUT /v1/applies/:id/invite — компания пригласила соискателя
  def invite
    @apply.update(read: true, invited: true)
    render json: @apply
  end

  private

  def set_apply
    @apply = Apply.find(params[:id])
  end

  def apply_params
    params.permit(:job_id, :geek_id, :read, :invited)
  end
end
