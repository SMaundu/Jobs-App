import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/custom_info_card.dart';
import '../../controllers/company_profile_controller.dart';
import '../../../../data/remote/base/status.dart'; // Ensure Status class is imported

class AboutUs extends GetView<CompanyProfileController> {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final companyStatus = controller.rxCompany; // Get the current status

        if (companyStatus.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (companyStatus.isSuccess) {
          final company = companyStatus.data; // Access data directly

          if (company == null) {
            return const SizedBox(); // Or a message indicating no company data
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                if (company.description != null && company.description!.isNotEmpty)
                  CustomInfoCard(
                    title: "About Company",
                    icon: HeroIcons.userCircle,
                    child: Text(
                      company.description!,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Get.theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                // Display Website info if available
                if (company.website != null && company.website!.isNotEmpty)
                  CustomInfoCard(
                    title: "Website",
                    icon: HeroIcons.globeAlt,
                    child: GestureDetector(
                      onTap: () async {
                        final url = Uri.parse(company.website!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          // Handle error, e.g., show a snackbar
                          Get.snackbar("Error", "Could not launch ${company.website}");
                        }
                      },
                      child: Text(
                        company.website!,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Get.theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                // Display Head office info if available
                if (company.headOffice != null && company.headOffice!.isNotEmpty)
                  CustomInfoCard(
                    title: "Head office",
                    icon: HeroIcons.mapPin,
                    child: Text(
                      company.headOffice!,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Get.theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                // Display Type info if available
                if (company.type != null && company.type!.isNotEmpty)
                  CustomInfoCard(
                    title: "Type",
                    icon: HeroIcons.homeModern,
                    child: Text(
                      company.type!,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Get.theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                // Display Since info if available
                if (company.foundedYear != null)
                  CustomInfoCard(
                    title: "Since",
                    icon: HeroIcons.cake,
                    child: Text(
                      company.foundedYear.toString(), // Convert int to String
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Get.theme.colorScheme.secondary,
                      ),
                    ),
                  ),
              ],
            ),
          );
        } else if (companyStatus.isError) {
          // Access message directly
          return Center(child: Text(companyStatus.message ?? "An error occurred."));
        }
        // Fallback for any unhandled state (e.g., initial idle state if not loading, success, or error)
        return Container();
      },
    );
  }
}
