//
//  ContentView.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/27/24.
//

import SwiftUI
import ComposableArchitecture


struct ContentView: View {
    // MARK: - properties
    @Perception.Bindable var store: StoreOf<MainScreen>
    
    // MARK: - init
    init(store: StoreOf<MainScreen>) {
        self.store = store
    }
    
    // MARK: - body
    var body: some View {
        WithPerceptionTracking {
            NavigationView { // nav stack
                VStack {
                    HStack { // header contains Today Text and an activity indicator (ProgressView)
                        Text(getDate(with: "EEEE d MMMM"))
                            .font(.title2.weight(.medium))
                        Spacer()
                        if store.state.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(1) // Scale up the activity indicator
                        }
                        
                    }.padding(.horizontal, 24)
                    
                    // MARK: - Show Error
                    if store.state.error != nil {
                        Text(store.state.error ?? "Something went wrong")
                            .foregroundColor(.white)
                            .padding()
                            .background(.red)
                            .cornerRadius(8)
                            .onAppear {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                            }
                    }
                    
                    // MARK: - Main Screen
                    ZStack(alignment: .bottom) {
                        // list of shifts
                        List(store.state.shifts) { data in
                            WithPerceptionTracking {
                                JobItemView(data: data, currentLocation: store.state.location)
                            }.listRowInsets(.init(top: 8, leading: 24, bottom: 8, trailing: 24))
                        }.listStyle(.plain)
                        
                        // filter and Kaart buttons
                        HStack {
                            Button(action: {
                                store.send(.filterButtonDidTapped)
                            }, label: {
                                HStack {
                                    Image(systemName: "line.3.horizontal.decrease.circle")
                                    Text("Filter")
                                        .font(.title2.weight(.semibold))
                                }.padding(.leading, 16)
                            }).frame(minWidth: 0, maxWidth: 120)
                                .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .tint(.black)
                            
                            Divider().frame(height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                            Button(action: {
                                store.send(.kaartButtonDidTapped)
                            }, label: {
                                HStack {
                                    Image(systemName: "mappin")
                                    Text("Kaart")
                                        .font(.title2.weight(.semibold))
                                }.padding(.trailing, 16)
                            }).frame(minWidth: 0, maxWidth: 120)
                                .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .tint(.black)
                        }
                        .background(.white)
                        .cornerRadius(25, corners: .allCorners)
                        .shadow(radius: 12)
                        .padding(.bottom, 32)
                    }
                    
                    // MARK: - footer
                    // sign in and login buttons
                    HStack {
                        Button(action: {
                            store.send(.signinButtonDidTapped)
                        }, label: {
                            Text("Sign up")
                                .font(.title2.weight(.semibold))
                        }).frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(.green)
                            .cornerRadius(12, corners: .allCorners)
                            .tint(.black)
                        
                        Button(action: {
                            store.send(.loginButtonDidTapped)
                        }, label: {
                            Text("Log in")
                                .font(.title2.weight(.semibold))
                        })
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.black, lineWidth: 1)
                        )
                        .cornerRadius(12, corners: .allCorners)
                        .tint(.black)
                        
                    }.padding()
                }
                .background()
                .onAppear(perform: {
                    getData()
                    store.send(.startUpdatingLocation)
                    
                }).onDisappear(perform: {
                    store.send(.stopUpdatingLocation)
                })
            }.colorScheme(.light)
            // MARK: - presentations
                .sheet(item: self.$store.scope(state: \.destination, action: \.destination)) { store in
                    SwitchStore(store) { initialState in
                        switch initialState {
                        case .map:
                            CaseLet(
                                \MainScreen.Destination.State.map, action: MainScreen.Destination.Action.map
                            ) { store in
                                MapKarrtView(store: store)
                            }
                            
                        case .filter:
                            EmptyView()
                        case .signup:
                            EmptyView()
                        case .login:
                            EmptyView()
                        }
                    }
                }
        }
    }
    
    func getData() {
        let currentDate = getDate(with: "yyyy-MM-dd")
        store.send(.fetchData(date: currentDate))
    }
    
    func getDate(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
}

//#Preview {
//    ContentView(store: .init(initialState: MainScreen.State(), reducer: {
//        MainScreen(locationService: .init())
//    }))
//}
