//
//  ContentView.swift
//  SensorRecorder
//
//  Created by jarvis on 2021/8/29.
//

import SwiftUI
import SwiftUICharts


struct ContentView: View {
    @ObservedObject var viewModel: MotionManager
    var body: some View {
        ScrollView{
            Text("\(Wrapper.openCVVersionString())")
            showImg()
            Spacer()
            HStack{
                VStack {
                    Text("Attitude Data")
                    Text("X: \(viewModel.sensorData.attitude.x)")
                    Text("Y: \(viewModel.sensorData.attitude.y)")
                    Text("Z: \(viewModel.sensorData.attitude.z)")
                }
                Spacer()
                VStack {
                    Text("Accelerometer Data")
                    Text("X: \(viewModel.sensorData.acc.x)")
                    Text("Y: \(viewModel.sensorData.acc.y)")
                    Text("Z: \(viewModel.sensorData.acc.z)")
                }
            }.padding()
            .font(.title3)
            Spacer()
            HStack{
                VStack {
                    Text("Gyroscope Data")
                    Text("X: \(viewModel.sensorData.gyr.x)")
                    Text("Y: \(viewModel.sensorData.gyr.y)")
                    Text("Z: \(viewModel.sensorData.gyr.z)")
                }
                Spacer()
                VStack {
                    Text("Magnetometer Data")
                    Text("X: \(viewModel.sensorData.mag.x)")
                    Text("Y: \(viewModel.sensorData.mag.y)")
                    Text("Z: \(viewModel.sensorData.mag.z)")
                }
            }.padding()
            .font(.title3)
            Spacer()

            //MARK: start charts
            let LineChartData = createData(data: viewModel.LineChartDataX, time: viewModel.TimeList)
            let data = LineChartData
            LineChart(chartData: LineChartData)
                .touchOverlay(chartData: data, specifier: "%.001f", unit: .suffix(of: "m/s^2"))
                .xAxisGrid(chartData: data)
                .yAxisGrid(chartData: data)
                .yAxisLabels(chartData: data, colourIndicator: .style(size: 12))
                .floatingInfoBox(chartData: data)
                .frame(minWidth: 300, maxWidth: 400, minHeight: 300, idealHeight: 500, maxHeight: 600, alignment: .center)
                .padding(.horizontal)
                .navigationTitle("Atitude")
            //MARK: end charts
            
            HStack{
                Button(action: {
                    viewModel.start()
                }, label: {
                    Image(systemName: "arrowtriangle.right.circle")
                })
                Spacer()
                Button(action: {
                    viewModel.stop()
                }, label: {
                    Image(systemName: "pause.circle")
                })
            }.font(.largeTitle)
            .padding()
        }
    }

    func showImg() -> Image? {
        let img = UIImage(named: "DSC00026.png")
        let img_gray = Wrapper.cvtColorBGR2GRAY(img)
        if let image  = img_gray {
            return Image(uiImage: image)
                .resizable()
        } else {
            return Image(systemName: "bolt.slash.fill")
        }
    }
    private var extraLineData: [ExtraLineDataPoint] {
        [ExtraLineDataPoint(value: 0),
         ExtraLineDataPoint(value: 0),
         ExtraLineDataPoint(value: 0),
         ExtraLineDataPoint(value: 0)]
    }
    private var extraLineStyle: ExtraLineStyle {
        ExtraLineStyle(lineColour: ColourStyle(colour: .blue),
                       lineType: .line,
                       yAxisTitle: "stationary")
    }
    
    func createMultiData(datax: Array<Double>, datay: Array<Double>, dataz: Array<Double>, time: Array<Double>) -> MultiLineChartData {
        let cnt = datax.count
        print("\(cnt)")
        var pointListX: Array<LineChartDataPoint> = Array<LineChartDataPoint>()
        var pointListY: Array<LineChartDataPoint> = Array<LineChartDataPoint>()
        var pointListZ: Array<LineChartDataPoint> = Array<LineChartDataPoint>()
        for index in 0..<cnt {
            pointListX.append(LineChartDataPoint(value: datax[index], xAxisLabel: "\(time[index])"))
            pointListY.append(LineChartDataPoint(value: datay[index], xAxisLabel: "\(time[index])"))
            pointListZ.append(LineChartDataPoint(value: dataz[index], xAxisLabel: "\(time[index])"))
        }
        let data = MultiLineDataSet(dataSets: [
            LineDataSet(dataPoints: pointListX,
            legendTitle: "Acc-X",
            pointStyle: PointStyle(pointType: .outline, pointShape: .circle),
            style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line)),
            
            LineDataSet(dataPoints: pointListY,
            legendTitle: "Acc-Y",
            pointStyle: PointStyle(pointType: .outline, pointShape: .square),
            style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .line)),
            
            LineDataSet(dataPoints: pointListZ,
            legendTitle: "Acc-Z",
            pointStyle: PointStyle(pointType: .outline, pointShape: .roundSquare),
            style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .line)),

        ])
        
        return MultiLineChartData(dataSets: data,
                                  metadata: ChartMetadata(title: "Acc", subtitle: "m/s^2"),
                                  xAxisLabels: ["start", "end"],
                                  chartStyle: LineChartStyle(infoBoxPlacement: .floating,
                                                             markerType: .full(attachment: .line(dot: .style(DotStyle()))),
                                                             xAxisGridStyle: GridStyle(numberOfLines: 12),
                                                             xAxisTitle: "Time",
                                                             yAxisGridStyle: GridStyle(numberOfLines: 5),
                                                             yAxisNumberOfLabels: 5,
                                                             yAxisTitle: "acceleration",
                                                             baseline: .minimumWithMaximum(of: -10.0),
                                                             topLine: .maximum(of: 10.0)))
    }
    
    func createData(data: Array<Double>, time: Array<Double>) -> LineChartData {
        let cnt = data.count
        var pointList: Array<LineChartDataPoint> = Array<LineChartDataPoint>()
        for index in 0..<cnt {
            pointList.append(LineChartDataPoint(value: data[index], xAxisLabel: "\(time[index])"))
        }
        let data = LineDataSet(dataPoints: pointList,
        legendTitle: "Acc-X",
        pointStyle: PointStyle(),
        style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine))
        
        let gridStyle = GridStyle(numberOfLines: 7,
                                  lineColour   : Color(.lightGray).opacity(0.5),
                                  lineWidth    : 1,
                                  dash         : [8],
                                  dashPhase    : 0)
        let chartStyle = LineChartStyle(infoBoxPlacement: .floating,
                                        markerType: .full(attachment: .line(dot: .style(DotStyle()))),
                                        
                                        xAxisGridStyle: gridStyle,
                                        xAxisTitle: "Time",
                                        yAxisGridStyle: gridStyle,
                                        yAxisNumberOfLabels: 5,
                                        yAxisTitle: "acceleration",
                                        baseline: .minimumWithMaximum(of: -10.0),
                                        topLine: .maximum(of: 10.0))
        
        let chartData = LineChartData(dataSets       : data,
                                      metadata       : ChartMetadata(title: "Local_Title",
                                                                     subtitle: "Local_Subtitle"),
                                      chartStyle     : chartStyle)
        
        return chartData
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MotionManager()
        ContentView(viewModel: viewModel)
    }
}
