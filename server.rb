require "sinatra"
require "pry"

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe",
}

get '/' do
  if session[:player_score].nil?
    player_score = 0
  else
    player_score = session[:player_score].to_i
  end

  if session[:computer_score].nil?
    computer_score = 0
  else
    computer_score = session[:computer_score].to_i
  end

  if session[:outcome_statement].nil?
    winner = ""
  else
    winner = session[:outcome_statemenmt]
  end

  if session[:player_choice].nil? || session[:computer_choice].nil?
    erb :index
  else

  outcomes = {
    'pr' => 'Paper beats rock, player wins the round.',
    'rp' => 'Paper beats rock, computer wins the round.',
    'rs' => 'Rock beats scissors, player wins the round.',
    'sr' => 'Rock beats scissors, computer wins the round.',
    'sp' => 'Scissors beats paper, player wins the round.',
    'ps' => 'Scissors beats paper, computer wins the round.',
    'rr' => 'Tie, choose again.',
    'pp' => 'Tie, choose again.',
    'ss' => 'Tie, choose again.'
  }

  winner = outcomes[session[:player_choice] + session[:computer_choice]]

  session[:outcome_statement] = winner

  if winner.include?('player')
    session[:player_score] = player_score + 1
    if session[:player_score] == 2
      session[:winner_statement] = "Player wins the game!"
      redirect "/win"
    end
  elsif winner.include?('computer')
    session[:computer_score] = computer_score + 1
    if session[:computer_score] == 2
      session[:winner_statement] = "Computer wins the game!"
      redirect "/win"
    end
  end

  erb :index

  end
end

post '/choose' do
  moves = ['r', 'p', 's']

  session[:player_choice] = params[:choice]
  session[:computer_choice] = moves.sample

  redirect '/'

end

post '/reset' do
  session[:player_score] = 0
  session[:computer_score] = 0
  session[:player_choice] = nil
  session[:computer_choice] = nil
  session[:outcome_statement] = nil

  redirect '/'
end

get '/win' do
  erb :win
end
