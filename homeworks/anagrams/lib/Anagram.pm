package Anagram;

use 5.010;
use strict;
use warnings;
use Encode qw(decode encode);
=encoding UTF8

=head1 SYNOPSIS

Поиск анаграмм

=head1 anagram($arrayref)

Функцию поиска всех множеств анаграмм по словарю.

Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8

Выходные данные: Ссылка на хеш множеств анаграмм.

Ключ - первое встретившееся в словаре слово из множества
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

Множества из одного элемента не должны попасть в результат.

Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например

anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])

должен вернуть ссылку на хеш


{
    'пятак'  => ['пятак', 'пятка', 'тяпка'],
    'листок' => ['листок', 'слиток', 'столик'],
}

=cut

sub anagram {
    my $words_list = shift;
    my %result;
    foreach my $word (@$words_list) {
		$word = lc(decode('UTF8',$word));
		$word = encode('UTF8', $word);
		my $have_key = return_key (\%result, $word);
    	if ($have_key) {
			my $arr_ref = $result{$have_key};
			unless (exists_in_arr($arr_ref,$word)) {
				push @$arr_ref, $word;
				@$arr_ref = sort @$arr_ref;
				$result{$have_key} = $arr_ref;
			}
		}
		else {
			$result{$word} = [$word];
		}
	}
	return rm_small_arrs(\%result);
};

sub return_key {
	my ($hash_ref, $add_word) = @_;
	foreach my $key (keys %$hash_ref) {
    	if (str_sort($key) eq str_sort($add_word)) {
			return $key;
    	}
	}
	return undef;
};

sub str_sort {
	my $word = shift;
	my @word = split '', $word;
	my $str = join '',sort @word;
	return lc($str);
};

sub exists_in_arr {
	my ($arr_ref, $word) = @_;
	return scalar grep /^$word$/, @$arr_ref;
}

sub rm_small_arrs {
	my $hash_ref = shift;
	foreach my $key (keys %$hash_ref) {
    	my $arr_ref = $hash_ref->{$key};
    	if ((scalar @$arr_ref) < 2){
        	delete $hash_ref->{$key};
    	}
	}
	return $hash_ref;
}
1;
