class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :set_comment_for_reply, only: [:reply, :do_reply]
  before_action :reply_authenticate, only: [:reply, :do_reply]
  before_action :modify_authenticate, except: [:reply, :do_reply, :show, :index, :create]

  def reply_authenticate
    redirect_to login_accounts_url, alert: "Must login first!" unless current_account
  end

  def modify_authenticate
    redirect_to login_accounts_url, alert: "Must Be ADMIN && Login!" unless current_admin?
  end

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  def reply
  end

  def do_reply
    @new_comment = Comment.new
    @new_comment.comment = @comment
    @new_comment.content = params[:content]
    @new_comment.account = current_account
    @new_comment.section = @section
    if @new_comment.save
      redirect_to commodity_section_comment_reply_path(@commodity, @section, @comment), notice: "增加新的评论"
    else
      redirect_to commodity_section_comment_reply_path(@commodity, @section, @comment), alert: {id: "评论增加失败！", type: "alert alert-danger", role: 'alert'}
    end
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.comment = @comment

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.section.commodity, notice: "评论被成功创建！" }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render @comment.section.record, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "评论被成功更新！" }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    commodity = @comment.section.commodity
    section = @comment.section
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to commodity_section_comments_url(commodity, section),
                                notice: "评论被成功销毁！" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_comment_for_reply
      @commodity = Commodity.find(params[:commodity_id])
      @section = Section.find(params[:section_id])
      @comment = Comment.find(params[:comment_id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :account_id, :section_id)
    end
end
