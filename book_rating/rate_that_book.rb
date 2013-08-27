# Dear baus,
# I bet that this is still shorter than your implementation
# Cordialement,
# => Where is my coffee

class Score
  attr_accessor :value, :book_reference

  def initialize(value=0, book_reference=-1)
    @value = value
    @book_reference = book_reference
  end
end

class BookRater
  attr_reader :books, :users, :ratings

  def initialize
    @books = []
    @ratings = Hash.new{ |k,v| k[v] = Score.new}
    counter = 0
    File.open('./data/books.txt', 'r') do |f|
      while line = f.gets do
        books << line.strip
        @ratings[counter]
        counter += 1
      end
    end

    @users = Hash.new { |k,v| k[v] = [] }
    File.open('./data/ratings.txt', 'r') do |f|
      cursor = 0
      cur_id = -1
      while line = f.gets do
        line = line.strip

        # if cursor == 0
        #   cur_id = line.split('User: ').last
        # else
        #   @users[cur_id] << line
        # end

        # cursor += 1
        # cursor = 0 if cursor == @books.count - 1

        if line.length > 2
          cur_id = line.split('User: ').last.to_i
        else
          @users[cur_id] << line.to_f
        end
      end
    end
  end

  def run
    do_scores
    output_rating
    nil
  end

  def do_scores
    @books.each_with_index do |book_i, i|
      @books[(i+1)..@books.length].each_with_index do |book_j, j|
        j += i+1
        current_score = score(i,j)

        if current_score > @ratings[i].value
          @ratings[i].value = current_score
          @ratings[i].book_reference = j
        end

        if current_score > @ratings[j].value
          @ratings[j].value = current_score
          @ratings[j].book_reference = i
        end
      end
    end

    # @books.each_with_index do |book_i, i|
    #   inner_books = @books.dup
    #   inner_books.each_with_index do |book_j, j|
    #     next if i == j
    #     current_score = score(i,j)
    #     p "#{current_score} #{i} #{j}"

    #     if current_score > @ratings[i].value
    #       @ratings[i].value = current_score
    #       @ratings[i].book_reference = j
    #     end
    #   end
    # end
  end

  def score(book_i, book_j)
    numerator, denominator1, denominator2 = 0.0, 0.0, 0.0
    @users.keys.each do |u|
      numerator += @users[u][book_i] * @users[u][book_j]
      denominator1 += (@users[u][book_i] ** 2)
      denominator2 += (@users[u][book_j] ** 2)
    end

    denominator = (Math.sqrt(denominator1) * Math.sqrt(denominator2))
    (numerator / denominator)
  end

  def output_rating
    @ratings.each {|k,v| output_text(k,v)}
  end

  def output_text(key, score)
    p "People who liked #{@books[key]} also liked #{@books[score.book_reference]} (Score = #{score.value})"
    # p "People who liked #{@books[key]} also liked #{@books[score.book_reference]} (Score = #{'%.3f' % score.value})"
  end

end
