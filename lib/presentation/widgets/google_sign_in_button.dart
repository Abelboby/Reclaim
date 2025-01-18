import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reclaim/core/constants/asset_constants.dart';
import '../../core/providers/auth_provider.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(8),
            minimumSize: const Size(220, 50),
          ),
          onPressed: authProvider.isLoading
              ? null
              : () async {
                  final error = await authProvider.signInWithGoogle();
                  if (error != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error)),
                    );
                  }
                },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AssetConstants.googleLogo,
                height: 24,
              ),
              const SizedBox(width: 12),
              Text(
                authProvider.isLoading 
                    ? 'Signing in...' 
                    : 'Sign in with Google',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 