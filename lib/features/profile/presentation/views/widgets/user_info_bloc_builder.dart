import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/features/profile/presentation/views/widgets/profile_view_body.dart';
import 'package:tree_clinic/presentation/manager/current_user_cubit/current_user_cubit.dart';

class UserInfoBlocBuilder extends StatelessWidget {
  const UserInfoBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        if (state is CurrentUserLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CurrentUserFailure) {
          return Center(child: Text(state.errMessage));
        }

        if (state is CurrentUserSuccess) {
          final user = state.userModel;

          return ProfileViewBody(user: user);
        }

        return const SizedBox();
      },
    );
  }
}
