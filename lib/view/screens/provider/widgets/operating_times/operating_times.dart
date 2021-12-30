import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_operating_times.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/add_operating_time.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/operating_time.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class OperatingTimes extends StatelessWidget {
  final int providerId;

  const OperatingTimes({required this.providerId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(
          ProviderOperatingTimesQuery().providerOperatingTimes,
        ),
        variables: {'providerId': providerId},
      ),
      builder: (
        QueryResult? providerOperatingTimesResult, {
        Future<void> Function()? refetch,
        FetchMore? fetchMore,
      }) {
        String? errorMessage;
        if (providerOperatingTimesResult!.hasException) {
          if (providerOperatingTimesResult
              .exception!.graphqlErrors.isNotEmpty) {
            errorMessage = providerOperatingTimesResult
                .exception!.graphqlErrors[0].message;
          }
        }

        if (providerOperatingTimesResult.isLoading) {
          return const AndroidLoading();
        }

        Map<String, dynamic>? data = providerOperatingTimesResult.data;
        List dayTimes = [];

        if (data != null && data['providerOperatingTimes'] != null) {
          dayTimes = data['providerOperatingTimes']['dayTimes'] ?? [];
        }

        return RefreshIndicator(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: AddOperatingTime(),
                        );
                      },
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.add_outlined, color: Colors.green),
                    title: Text('Click to add business day'),
                  ),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                if (dayTimes.isEmpty)
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: const Text(
                      'You currently have no business operating times set',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ...dayTimes.map((dayTime) {
                  return OperatingTime(
                    dayTimeId: dayTime['id'],
                    day: dayTime['day']['day'],
                    startTime: dayTime['time']['startTime'],
                    endTime: dayTime['time']['endTime'],
                  );
                }).toList(),
              ],
            ),
          ),
          onRefresh: refetch!,
        );
      },
    );
  }
}
