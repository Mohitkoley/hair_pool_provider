import 'package:demandium_provider/utils/core_export.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class BookingInformationView extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final bool isSubBooking;
  const BookingInformationView(
      {super.key, required this.bookingDetails, required this.isSubBooking});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>(
        builder: (bookingDetailsController) {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow:
                Get.find<ThemeController>().darkTheme ? null : lightShadow),
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeSmall,
            horizontal: Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(children: [
                    Text(
                      '${'booking'.tr} # ${bookingDetails.readableId}',
                      overflow: TextOverflow.ellipsis,
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color
                              ?.withOpacity(0.9),
                          decoration: TextDecoration.none),
                    ),
                    if (isSubBooking)
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        child: const Icon(
                          Icons.repeat,
                          color: Colors.white,
                          size: 12,
                        ),
                      )
                  ]),
                ),
                (bookingDetails.bookingStatus != "canceled")
                    ? GestureDetector(
                        onTap: () async {
                          _checkPermission(() async {
                            if (bookingDetails.serviceAddress != null ||
                                bookingDetails.subBooking?.serviceAddress !=
                                    null) {
                              showCustomDialog(child: const CustomLoader());
                              await Geolocator.getCurrentPosition()
                                  .then((position) {
                                MapUtils.openMap(
                                  double.tryParse(
                                          bookingDetails.serviceAddress?.lat ??
                                              bookingDetails.subBooking
                                                  ?.serviceAddress?.lat ??
                                              "0") ??
                                      23.8103,
                                  double.tryParse(
                                          bookingDetails.serviceAddress?.lon ??
                                              bookingDetails.subBooking
                                                  ?.serviceAddress?.lon ??
                                              "0") ??
                                      90.4125,
                                  position.latitude,
                                  position.longitude,
                                );
                              });
                              Get.back();
                            } else {
                              showCustomSnackBar(
                                  "service_address_not_found".tr);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeExtraSmall + 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Get.isDarkMode
                                ? Colors.grey.withOpacity(0.2)
                                : ColorResources.buttonBackgroundColorMap[
                                    bookingDetails.bookingStatus],
                          ),
                          child: Center(
                            child: Text(
                              "view_on_map".tr,
                              style: robotoMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Get.isDarkMode
                                      ? Theme.of(context).primaryColorLight
                                      : ColorResources.buttonTextColorMap[
                                          bookingDetails.bookingStatus]),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Get.isDarkMode
                              ? Colors.grey.withOpacity(0.2)
                              : ColorResources.buttonBackgroundColorMap[
                                  bookingDetails.bookingStatus],
                        ),
                        child: Center(
                          child: Text(
                            "canceled".tr,
                            style: robotoMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Get.isDarkMode
                                    ? Theme.of(context).primaryColorLight
                                    : ColorResources.buttonTextColorMap[
                                        bookingDetails.bookingStatus]),
                          ),
                        ),
                      )
              ],
            ),
            if (bookingDetails.bookingStatus != "canceled")
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RichText(
                  text: TextSpan(
                      text: '${'Booking_Status'.tr} : ',
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault - 1,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      children: [
                        TextSpan(
                            text: bookingDetails.bookingStatus?.tr,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault - 1,
                              color: ColorResources.buttonTextColorMap[
                                  bookingDetails.bookingStatus],
                              decoration: TextDecoration.none,
                            )),
                      ]),
                ),
              ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            BookingItem(
              img: Images.iconCalendar,
              title: '${'booking_date'.tr} : ',
              subTitle: DateConverter.dateMonthYearTime(
                  DateConverter.isoUtcStringToLocalDate(
                      bookingDetails.createdAt!)),
            ),
            if (bookingDetails.serviceSchedule != null)
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            if (bookingDetails.serviceSchedule != null)
              BookingItem(
                img: Images.iconCalendar,
                title: '${'scheduled_date'.tr} : ',
                subTitle:
                    ' ${DateConverter.dateMonthYearTime(DateTime.tryParse(bookingDetails.serviceSchedule!))}',
              ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            BookingItem(
              img: Images.iconLocation,
              title:
                  '${'Address'.tr} : ${bookingDetails.serviceAddress?.address ?? bookingDetails.subBooking?.serviceAddress?.address ?? 'address_not_found'.tr}',
              subTitle: '',
            ),
          ],
        ),
      );
    });
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr, type: ToasterMessageType.info);
    } else if (permission == LocationPermission.deniedForever) {
      showCustomDialog(
          child: const PermissionDialog(), barrierDismissible: true);
    } else {
      onTap();
    }
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(
      double destinationLatitude,
      double destinationLongitude,
      double userLatitude,
      double userLongitude) async {
    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude'
        '&destination=$destinationLatitude,$destinationLongitude&mode=d';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }
}
