import 'package:demandium_provider/helper/booking_helper.dart';
import 'package:get/get.dart';
import 'package:demandium_provider/utils/core_export.dart';

class BookingRequestItem extends StatelessWidget {
  final BookingRequestModel bookingRequestModel;
  const BookingRequestItem({
    super.key, required this.bookingRequestModel,});

  @override
  Widget build(BuildContext context) {
    var ongoingRepeatBooking = BookingHelper.getCurrentOngoingRepeatBooking(bookingRequestModel);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: Get.find<ThemeController>().darkTheme ? null : lightShadow,
      ),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
      child: Stack(children: [

        Column(crossAxisAlignment: CrossAxisAlignment.start , children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
              Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall + 3,
            ),
            child: Row( crossAxisAlignment: CrossAxisAlignment.start, children: [ Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("booking".tr,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.7),
                        ),
                      ),
                      Text(" # ${bookingRequestModel.readableId}",
                        style: robotoBold.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.8),
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      if(bookingRequestModel.isRepeatBooking == 1)Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: const Icon(Icons.repeat, color: Colors.white,size: 12,),
                      )
                    ],
                  ),
                  Text(bookingRequestModel.subCategory?.name ?? " ",
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall + 2,  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),),
            ],
            ),
          ),

          Container(height: 2,width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
              Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(children: [
                    Row(
                      children: [
                        Text("${'booking_date'.tr}: ",
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,   color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6))
                        ),
                        Expanded(
                          child: Text(" ${DateConverter.dateMonthYearTime(DateConverter
                              .isoUtcStringToLocalDate(bookingRequestModel.createdAt!))}",
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,   color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                            textDirection: TextDirection.ltr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                    Row(
                      children: [
                        Text("${'scheduled_date'.tr}: ",
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall ,  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6))
                        ),
                        if(BookingHelper.getRepeatBookingCurrentSchedule(bookingRequestModel) !=null ) Expanded(
                          child: Text(DateConverter.dateMonthYearTime(DateTime.tryParse(BookingHelper.getRepeatBookingCurrentSchedule(bookingRequestModel)!)),
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall ,  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                            textDirection: TextDirection.ltr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('total_amount'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,  color: Theme.of(context).secondaryHeaderColor),
                    ),
                    Text(PriceConverter.convertPrice(bookingRequestModel.totalBookingAmount ?? 0),
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColorLight),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],),
        Positioned.fill(child: CustomInkWell(
          onTap: (){
            if(bookingRequestModel.isRepeatBooking == 1){
              Get.toNamed(RouteHelper.getRepeatBookingDetailsRoute(bookingId : bookingRequestModel.id!));
            }else{
              Get.toNamed(RouteHelper.getBookingDetailsRoute(bookingId : bookingRequestModel.id!));
            }
          }

        )),

        Positioned(
          right: 10,
          top: 15,
          child: GetBuilder<BookingRequestController>(builder: (bookingRequestController){
            return PopupMenuButton<PopupMenuModel>(
              shape:  RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault,)),
                  side: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.1))
              ),
              surfaceTintColor: Theme.of(context).cardColor,
              position: PopupMenuPosition.under, elevation: 8,
              shadowColor: Theme.of(context).hintColor.withOpacity(0.3),
              itemBuilder: (BuildContext context) {
                return bookingRequestController.getPopupMenuList( status : bookingRequestModel.bookingStatus ?? "", isRepeatBooking: bookingRequestModel.isRepeatBooking == 1, ongoingRepeatBooking: ongoingRepeatBooking).map((PopupMenuModel option) {
                  return PopupMenuItem<PopupMenuModel>(
                    onTap: ()async{
                      if(option.title == "booking_details" || option.title == "full_booking_details"){
                        if(bookingRequestModel.isRepeatBooking == 1){
                          Get.toNamed(RouteHelper.getRepeatBookingDetailsRoute(bookingId : bookingRequestModel.id!));
                        }else{
                          Get.toNamed(RouteHelper.getBookingDetailsRoute( bookingId: bookingRequestModel.id));
                        }
                      } else if(option.title == "accept"){
                        if(Get.find<UserProfileController>().providerModel?.content?.subscriptionInfo?.subscribedPackageDetails?.isCanceled == 1){
                          showCustomSnackBar("your_subscription_plan_has_been_cancelled_you_will_not_able_to_accept_any_booking_request".tr, type : ToasterMessageType.info);
                        }else{
                          Get.find<BusinessSubscriptionController>().openTrialEndBottomSheet().then((isTrial){
                            if(isTrial){
                              showCustomDialog(child:  ConfirmationDialog(
                                noButtonColor: Theme.of(Get.context!).colorScheme.error,
                                noTextColor: Colors.white,
                                yesButtonColor: Theme.of(Get.context!).primaryColor,
                                title: "want_accept_this_booking?".tr,
                                icon: Images.servicemanImage,
                                description: 'accept_booking_hint_text'.tr,
                                onYesPressed: (){
                                  Get.find<BookingDetailsController>().acceptBookingRequest(bookingRequestModel.id!);
                                  Get.back();
                                },
                                onNoPressed: () => Get.back(),

                              ));
                            }
                          });
                        }
                      }else if(option.title == "ignore"){
                        showCustomDialog(child:  ConfirmationDialog(
                          yesButtonColor: Theme.of(Get.context!).primaryColor,
                          title: "are_you_sure_to_ignore_the_booking_request".tr,
                          description: "once_you_ignore_the_request",
                          noButtonColor: Theme.of(context).colorScheme.error,
                          noTextColor: Colors.white,
                          icon: Images.warning,
                          noButtonText: "cancel",
                          onYesPressed: () {
                            Get.find<BookingDetailsController>().ignoreBookingRequest(bookingRequestModel.id!);
                            Get.back();
                            Get.back();
                          },

                        ),);
                      }else if(option.title == "download_invoice" || option.title == "download_full_invoice"){
                        String languageCode = Get.find<LocalizationController>().locale.languageCode;
                        String uri = "${AppConstants.baseUrl}${ bookingRequestModel.isRepeatBooking == 1 ? AppConstants.fullRepeatBookingInvoiceUrl : AppConstants.regularBookingInvoiceUrl}${bookingRequestModel.id}/$languageCode";
                        if (kDebugMode) {
                          print("Uri : $uri");
                        }
                        await _launchUrl(Uri.parse(uri));
                      }
                      else if(option.title == "download_ongoing_invoice" || option.title == "download_upcoming_invoice"){
                        String languageCode = Get.find<LocalizationController>().locale.languageCode;
                        String uri = "${AppConstants.baseUrl}${AppConstants.singleRepeatBookingInvoiceUrl}${ongoingRepeatBooking!.id}/$languageCode";
                        if (kDebugMode) {
                          print("Uri : $uri");
                        }
                        await _launchUrl(Uri.parse(uri));
                      }
                      else if(option.title == "ongoing_booking_details" || option.title == "upcoming_booking_details"){
                        Get.toNamed(RouteHelper.getBookingDetailsRoute( subBookingId:  ongoingRepeatBooking!.id!));
                      }




                    },
                    value: option,
                    height: 35,
                    child: Row(
                      children: [
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                        Icon(option.icon, size: Dimensions.fontSizeLarge,),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        Text(option.title.tr.capitalizeFirst ?? "", style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall
                        ),),
                      ],
                    ),
                  );
                }).toList();
              },
              child: Icon(Icons.more_vert, color: Theme.of(context).hintColor.withOpacity(0.7),),
            );
          }),
        ),

      ]),
    );
  }
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
