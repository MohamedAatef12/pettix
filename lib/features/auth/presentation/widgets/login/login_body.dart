import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';
import 'package:pettix/features/auth/presentation/widgets/login/login_form.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.large,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/horizontal_logo.png',
              height: 25.h,width: 100.w,
            fit: BoxFit.fill,
            ),
            SizedBox(height: 20.h,),
            SizedBox(
              width: 250.w,
              child: Text('Sign in to your Account',
              style: AppTextStyles.title,),
            ),
        
            Text('Enter your email and password to log in ',style: AppTextStyles.smallDescription,),
            SizedBox(height: 50.h,),
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
              current is GoogleLoginSuccess || current is LoginSuccess, // ✅ include both
              listener: (context, state) {
                if (state is GoogleLoginSuccess || state is LoginSuccess) {
                  context.push(AppRoutes.bottomNav);
                }
              },
              child: const LoginForm(),
            )
          ],
        ),
      ),
    );
  }
}
