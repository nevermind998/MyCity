using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;

namespace backendPoSlojevima.UI
{
    public class ReportKomentaraUI : IReportKomentaraUI
    {
        private readonly IReportKomentaraBL _IReportKomentaraBL;
        public ReportKomentaraUI(IReportKomentaraBL IReportKomentaraBL)
        {
            _IReportKomentaraBL = IReportKomentaraBL;
        }

        public long brojReportovaZaVlasnikaKomentara(long idKorisnika)
        {
            return _IReportKomentaraBL.brojReportovaZaVlasnikaKomentara(idKorisnika);
        }

        public void deleteReportoveKomentaraByIdKomentara(long idKomentara)
        {
            _IReportKomentaraBL.deleteReportoveKomentaraByIdKomentara(idKomentara);
        }

        public void deleteReportoveKomentaraByIdKorisnika(long idKorisnika)
        {
            _IReportKomentaraBL.deleteReportoveKomentaraByIdKorisnika(idKorisnika);
        }

        public List<ReportKomentari> getAllReport()
        {
            return _IReportKomentaraBL.getAllReport();
        }

        public long getBrojReportaByIdKomentara(long idKomentara)
        {
            return _IReportKomentaraBL.getBrojReportaByIdKomentara(idKomentara);
        }

        public List<Korisnik> getKorisnikeKojiReportujuByIdKomentara(long idKomentara)
        {
            return _IReportKomentaraBL.getKorisnikeKojiReportujuByIdKomentara(idKomentara);
        }

        public MinMaxReportova getMinIMaxBroj()
        {
            MinMaxReportova data = new MinMaxReportova();
            data.min = 0;
            data.max = _IReportKomentaraBL.maxReportova();
            return data;
        }

        public int getReportKomentaraByIdKorisnika(long idKorisnika, long idKomentara)
        {
            return _IReportKomentaraBL.getReportKomentaraByIdKorisnika(idKorisnika, idKomentara);
        }

        public List<ReportKomentari> getReportoveKomentaraByIdKomentara(long idKomentara)
        {
            return _IReportKomentaraBL.getReportoveKomentaraByIdKomentara(idKomentara);
        }

        public List<ReportKomentari> getReportoveKomentaraByKorisnikId(long korisnik)
        {
            return _IReportKomentaraBL.getReportoveKomentaraByKorisnikId(korisnik);
        }

        

        public void saveReport(ReportKomentari data)
        {
            _IReportKomentaraBL.saveReport(data);
        }
    }
}
