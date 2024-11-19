import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'review_account_state.dart';

class ReviewAccountCubit extends Cubit<ReviewAccountState> {
  ReviewAccountCubit() : super(ReviewAccountInitial());
}
