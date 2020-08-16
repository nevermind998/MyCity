using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI
{
    public class ReportUI : IReportUI
    {
        private readonly IReportBL _IReportBL;

        public ReportUI(IReportBL IReportBL)
        {
            _IReportBL = IReportBL;
        }

        public long brojReportovaZaVlasnikaObjava(long idKorisnika)
        {
            return _IReportBL.brojReportovaZaVlasnikaObjava(idKorisnika);
        }

        public long dajSveReportoveByIdObjave(PrihvatanjeIdObjave objava)
        {
            return _IReportBL.dajSveReportoveByIdObjave(objava.idObjave);
        }

        public void deleteReportoveByIdKorisnika(long idKorisnika)
        {
            _IReportBL.deleteReportoveByIdKorisnika(idKorisnika);
        }

        public void deleteReportoveByIdObjave(long idObjave)
        {
            _IReportBL.deleteReportoveByIdObjave(idObjave);
        }

        public List<Report> getAllReport()
        {
            return _IReportBL.getAllReport();
        }

        public List<Korisnik> getKorisnikeKojiReportujuByIdObjave(PrihvatanjeIdObjave objava)
        {
            return _IReportBL.getKorisnikeKojiReportujuByIdObjave(objava.idObjave);
        }

        

        public MinMaxReportova getMinIMaxBroj()
        {

            MinMaxReportova data = new MinMaxReportova();
            data.min = 0;
            data.max = _IReportBL.maxReportova();
            return data;

        }

        public List<RazlogPrijave> getRazlogePrijave()
        {
            return _IReportBL.getRazlogePrijave();
        }

        public int getReportByKorisnikId(long idKorisnika, long idObjave)
        {
            return _IReportBL.getReportByKorisnikId(idKorisnika, idObjave);
        }

        public List<Objave> getReportovaneObjave()
        {
            return _IReportBL.getReportovaneObjave();

        }

        public List<Objave> getReportovaneObjaveByIdGrada(long idGrada)
        {
            return _IReportBL.getReportovaneObjaveByIdGrada(idGrada);
        }

        public List<Objave> getReportovaneObjaveByIdGrada30Dana(long idGrada)
        {
            return _IReportBL.getReportovaneObjaveByIdGrada30Dana(idGrada);
        }

        public List<Objave> getReportovaneObjaveByIdGrada7Dana(long idGrada)
        {
            return _IReportBL.getReportovaneObjaveByIdGrada7Dana(idGrada);
        }

        public List<Report> getReportoveByIdObjave(long idObjave)
        {
            return _IReportBL.getReportoveByIdObjave(idObjave);
        }

        public List<Report> getReportoveByKoirsnikId(long idKorisnik)
        {
            return _IReportBL.getReportoveByKoirsnikId(idKorisnik);
        }

        public int saveReport(Report data)
        {
           return  _IReportBL.saveReport(data);
        }

        public List<KorisnikIRazlogPrijave> getKorisnikeIRazlogPrijave(long idObjave)
        {
            return _IReportBL.getKorisnikeIRazlogPrijave(idObjave);
        }
    }
}
