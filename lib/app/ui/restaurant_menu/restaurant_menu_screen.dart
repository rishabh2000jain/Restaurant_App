import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/app/bloc/bloc_common_state.dart';
import 'package:restaurant_app/app/bloc/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:restaurant_app/app/bloc/restaurant_menu/restaurant_menu_events.dart';
import 'package:restaurant_app/app/bloc/restaurant_menu/restaurant_menu_states.dart';
import 'package:restaurant_app/app/ui/restaurant_menu/widgets/menu_list.dart';
import 'package:restaurant_app/resources/strings.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen>
    with SingleTickerProviderStateMixin {
  late RestaurantMenuBloc _restaurantMenuBloc;

  @override
  void initState() {
    _restaurantMenuBloc = BlocProvider.of<RestaurantMenuBloc>(context);
    _restaurantMenuBloc.add(GetRestaurantEvent());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<RestaurantMenuBloc, RestaurantMenuStates>(
                bloc: _restaurantMenuBloc,
                listener: (BuildContext context, RestaurantMenuStates state) {
                  if (state is PlaceOrderOrderState) {
                    if (state.status == Status.completed) {
                      _showOrderCompleteDialog();
                      _restaurantMenuBloc.add(GetRestaurantEvent());
                    }
                  }
                },
                buildWhen: (prevState, currState) {
                  return currState is GetRestaurantMenuState ||
                      currState is RestaurantMenuInitialState;
                },
                builder: (BuildContext context, RestaurantMenuStates state) {
                  if (state is GetRestaurantMenuState) {
                    if (state.status == Status.completed) {
                      return MenuList(
                        menuCategory: state.data!,
                      );
                    } else if (state.status == Status.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.kSomethingWentWrong,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  _restaurantMenuBloc.add(GetRestaurantEvent());
                                },
                                child: const Text(AppStrings.kTryAgain))
                          ],
                        ),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
            BlocBuilder<RestaurantMenuBloc, RestaurantMenuStates>(
              buildWhen: (prevState, currState) {
                return currState is RestaurantMenuInitialState ||
                    currState is DeleteOrderSessionState ||
                    currState is UpdateCurrentCostState;
              },
              builder: (BuildContext context, RestaurantMenuStates state) {
                if (state is UpdateCurrentCostState) {
                  num price = state.data;
                  return InkWell(
                    onTap: () {
                      _restaurantMenuBloc.add(PlaceOrderOrderEvent());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 65,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            AppStrings.kPlaceOrder,
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w700),
                          ),
                          Positioned(
                            right: 20,
                            child: Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }

  void _showOrderCompleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                AppStrings.kOk,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
          content: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            height: 70,
            child: Column(
              children: const [
                Text(
                  AppStrings.kOrderPlacedSuccess,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
