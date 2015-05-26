module Api
  module V1
    class BooksController < Api::V1::BaseController

      private

      def book_params
        params.require(:book).permit(:title)
      end

      def query_params
        params.permit(:title)
      end

    end
  end
end  